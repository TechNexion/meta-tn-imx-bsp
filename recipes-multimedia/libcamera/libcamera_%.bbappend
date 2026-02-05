# add parameter
#EXTRA_OEMESON:append = " -Dqcam=disabled"
#EXTRA_OEMESON:append = " --buildtype=release"

python __anonymous () {
    # 1. Retrieve the current EXTRA_OEMESON variable
    oem_meson = d.getVar('EXTRA_OEMESON')
    if not oem_meson:
        return

    import re
    # 2. Search for the -Dpipelines= pattern
    pattern = r'-Dpipelines=([^ ]+)'
    match = re.search(pattern, oem_meson)

    if match:
        original_pipelines_str = match.group(1)
        # 3. Split the string into a list
        pipelines_list = original_pipelines_str.split(',')

        # 4. Define the items to be re-ordered/moved to the front
        target_items = ['nxp/neo', 'imx8-isi']

        # 5. Filter out target items from the current list to prevent duplicates
        remaining_items = [p for p in pipelines_list if p not in target_items]

        # 6. Prepend the target items to the front of the list
        final_pipelines_list = target_items + remaining_items

        # 7. Construct the new parameter string
        new_pipelines_param = "-Dpipelines=" + ",".join(final_pipelines_list)

        # 8. Replace the old segment with the new one in EXTRA_OEMESON
        new_oem_meson = oem_meson.replace(match.group(0), new_pipelines_param)
        d.setVar('EXTRA_OEMESON', new_oem_meson)
}

