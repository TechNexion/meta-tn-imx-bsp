# Copyright (C) 2015-2022 Stefano Babic
#
# SPDX-License-Identifier: GPLv3

inherit swupdate-common

def swupdate_write_sha256(workdir):
    import re
    write_lines = []
    with open(os.path.join(workdir, "sw-description"), 'r') as f:
       for line in f:
          shastr = r"sha256.+=.+@(.+\")"
          m = re.match(r"^(?P<before_placeholder>.+)(sha256|version).+[=:].*(?P<quote>[\'\"])@(?P<filename>.*)(?P=quote)", line)
          if m:
              filename = m.group('filename')
              bb.warn("Syntax for sha256 changed, please use $swupdate_get_sha256(%s)" % filename)
              hash = swupdate_get_sha256(None, workdir, filename)
              write_lines.append(line.replace("@%s" % (filename), hash))
          else:
              write_lines.append(line)

    with open(os.path.join(workdir, "sw-description"), 'w+') as f:
        for line in write_lines:
            f.write(line)

def swupdate_expand_bitbake_variables(d, s, workdir):
    write_lines = []

    with open(os.path.join(s, "sw-description"), 'r') as f:
        import re
        for line in f:
            found = False
            while True:
                m = re.match(r"^(?P<before_placeholder>.*)@@(?P<bitbake_variable_name>\w+)@@(?P<after_placeholder>.*)$", line)
                if m:
                    bitbake_variable_value = d.getVar(m.group('bitbake_variable_name'), True)
                    if bitbake_variable_value is None:
                       bitbake_variable_value = ""
                       bb.warn("BitBake variable %s not set" % (m.group('bitbake_variable_name')))
                    line = m.group('before_placeholder') + bitbake_variable_value + m.group('after_placeholder')
                    found = True
                    continue
                else:
                    m = re.match(r"^(?P<before_placeholder>.*)@@(?P<bitbake_variable_name>.+)\[(?P<flag_var_name>.+)\]@@(?P<after_placeholder>.*)$", line)
                    if m:
                       bitbake_variable_value = (d.getVarFlag(m.group('bitbake_variable_name'), m.group('flag_var_name'), True) or "")
                       if bitbake_variable_value is None:
                          bitbake_variable_value = ""
                       line = m.group('before_placeholder') + bitbake_variable_value + m.group('after_placeholder')
                       continue

                    if found:
                       line = line + "\n"
                    break

            write_lines.append(line)

    swupdate_exec_functions(d, workdir, write_lines)

    with open(os.path.join(workdir, "sw-description"), 'w+') as f:
        for line in write_lines:
            f.write(line)

def prepare_sw_description(d):
    import shutil
    import subprocess

    s = d.getVar('S')
    workdir = d.getVar('WORKDIR')
    swupdate_expand_bitbake_variables(d, s, workdir)

    swupdate_write_sha256(workdir)

    encrypt = d.getVar('SWUPDATE_ENCRYPT_SWDESC')
    if encrypt:
        bb.note("Encryption of sw-description")
        shutil.copyfile(os.path.join(workdir, 'sw-description'), os.path.join(workdir, 'sw-description.plain'))
        key,iv = swupdate_extract_keys(d.getVar('SWUPDATE_AES_FILE'))
        iv = swupdate_get_IV(d, workdir, 'sw-description')
        swupdate_encrypt_file(os.path.join(workdir, 'sw-description.plain'), os.path.join(workdir, 'sw-description'), key, iv)

    signing = d.getVar('SWUPDATE_SIGNING')
    if signing == "1":
        bb.warn('SWUPDATE_SIGNING = "1" is deprecated, falling back to "RSA". It is advised to set it to "RSA" if using RSA signing.')
        signing = "RSA"
    if signing:

        sw_desc_sig = os.path.join(workdir, 'sw-description.sig')
        sw_desc =  os.path.join(workdir, 'sw-description.plain' if encrypt else 'sw-description')

        if signing == "CUSTOM":
            signcmd = []
            sign_tool = d.getVar('SWUPDATE_SIGN_TOOL')
            signtool = sign_tool.split()
            for i in range(len(signtool)):
                signcmd.append(signtool[i])
            if not signcmd:
                bb.fatal("Custom SWUPDATE_SIGN_TOOL is not given")
        elif signing == "RSA":
            privkey = d.getVar('SWUPDATE_PRIVATE_KEY')
            if not privkey:
                bb.fatal("SWUPDATE_PRIVATE_KEY isn't set")
            if not os.path.exists(privkey):
                bb.fatal("SWUPDATE_PRIVATE_KEY %s doesn't exist" % (privkey))
            signcmd = ["openssl", "dgst", "-sha256", "-sign", privkey] + get_pwd_file_args(d, 'SWUPDATE_PASSWORD_FILE') + ["-out", sw_desc_sig, sw_desc]
        elif signing == "CMS":
            cms_cert = d.getVar('SWUPDATE_CMS_CERT')
            if not cms_cert:
                bb.fatal("SWUPDATE_CMS_CERT is not set")
            if not os.path.exists(cms_cert):
                bb.fatal("SWUPDATE_CMS_CERT %s doesn't exist" % (cms_cert))
            cms_key = d.getVar('SWUPDATE_CMS_KEY')
            if not cms_key:
                bb.fatal("SWUPDATE_CMS_KEY isn't set")
            if not os.path.exists(cms_key):
                bb.fatal("SWUPDATE_CMS_KEY %s doesn't exist" % (cms_key))
            signcmd = ["openssl", "cms", "-sign", "-in", sw_desc, "-out", sw_desc_sig, "-signer", cms_cert, "-inkey", cms_key] + \
                        ["-outform", "DER", "-nosmimecap", "-binary"] + \
                        get_pwd_file_args(d, 'SWUPDATE_PASSWORD_FILE') + \
                        get_certfile_args(d)
        else:
            bb.fatal("Unrecognized SWUPDATE_SIGNING mechanism.")
        subprocess.run(' '.join(signcmd), shell=True, check=True)


def swupdate_add_src_uri(d, list_for_cpio):
    import shutil

    workdir = d.getVar('WORKDIR')
    exclude = (d.getVar("SWUPDATE_SRC_URI_EXCLUDE") or "").split()

    fetch = bb.fetch2.Fetch([], d)

    # Add files listed in SRC_URI to the swu file
    for url in fetch.urls:
        local = fetch.localpath(url)
        filename = os.path.basename(local)
        if filename in exclude:
            continue
        aes_file = d.getVar('SWUPDATE_AES_FILE')
        if aes_file:
            key,iv = swupdate_extract_keys(d.getVar('SWUPDATE_AES_FILE'))
        if (filename != 'sw-description') and (os.path.isfile(local)):
            encrypted = (d.getVarFlag("SWUPDATE_IMAGES_ENCRYPTED", filename) or "")
            dst = os.path.join(workdir, "%s" % filename )
            if encrypted == '1':
                bb.note("Encryption requested for %s" %(filename))
                if not key or not iv:
                    bb.fatal("Encryption required, but no key found")
                iv = swupdate_get_IV(d, workdir, filename)
                swupdate_encrypt_file(local, dst, key, iv)
            else:
                shutil.copyfile(local, dst)
            list_for_cpio.append(filename)

def swupdate_add_artifacts(d, list_for_cpio):
    import shutil
    # Search for images listed in SWUPDATE_IMAGES in the DEPLOY directory.
    images = (d.getVar('SWUPDATE_IMAGES') or "").split()
    deploydir = d.getVar('DEPLOY_DIR_IMAGE')
    imgdeploydir = d.getVar('SWUDEPLOYDIR')
    workdir = d.getVar('WORKDIR')
    for image in images:
        fstypes = (d.getVarFlag("SWUPDATE_IMAGES_FSTYPES", image) or "").split()
        encrypted = (d.getVarFlag("SWUPDATE_IMAGES_ENCRYPTED", image) or "")
        if fstypes:
            noappend_machine = d.getVarFlag("SWUPDATE_IMAGES_NOAPPEND_MACHINE", image)
            if noappend_machine == "0":  # Search for a file explicitly with MACHINE
                imagebases = [ image + '-' + d.getVar('MACHINE') ]
            elif noappend_machine == "1":  # Search for a file explicitly without MACHINE
                imagebases = [ image ]
            else:  # None, means auto mode. Just try to find an image file with MACHINE or without MACHINE
                imagebases = [ image + '-' + d.getVar('MACHINE'), image ]
            for fstype in fstypes:
                image_found = False
                for imagebase in imagebases:
                    image_found = add_image_to_swu(d, deploydir, imagebase + fstype, workdir, encrypted, list_for_cpio)
                    if image_found:
                        break
                if not image_found:
                    bb.fatal("swupdate cannot find image file: %s" % os.path.join(deploydir, imagebase + fstype))
        else:  # Allow also complete entries like "image.ext4.gz" in SWUPDATE_IMAGES
            if not add_image_to_swu(d, deploydir, image, workdir, encrypted, list_for_cpio):
                bb.fatal("swupdate cannot find %s image file" % image)


def swupdate_create_cpio(d, swudeploydir, list_for_cpio):
    workdir = d.getVar('WORKDIR')
    os.chdir(workdir)
    updateimage = d.getVar('IMAGE_NAME') + '.swu'
    line = 'for i in ' + ' '.join(list_for_cpio) + '; do echo $i;done | cpio -ov -H crc --reproducible > ' + os.path.join(swudeploydir, updateimage)
    os.system(line)
    os.chdir(swudeploydir)
    updateimage_link = d.getVar('IMAGE_LINK_NAME')
    if updateimage_link:
        updateimage_link += '.swu'
        if updateimage_link != updateimage:
            os.symlink(updateimage, updateimage_link)
