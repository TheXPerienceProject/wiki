{% assign device = site.data.devices[page.device] %}
{% include alerts/warning.html content="These instructions only work if you follow every section and step precisely.<br/>
Do **not** continue after something fails!" %}

## Basic requirements


1. Read through the instructions at least once before actually following them, so as to avoid any problems due to any missed steps!
2. Make sure your computer has `adb`{% unless device.install_method == 'heimdall' or device.install_method == 'dd' %} and `fastboot`{% endunless %}. Setup instructions can be found [here]({{ "help/adb-fastboot-guide/" | relative_url }}).
3. Enable [USB debugging]({{ "help/adb-fastboot-guide/#setting-up-adb" | relative_url }}) on your device.
{%- if device.models %}
4. Make sure that your model number is one of the following (exact match required!):
 {%- for model in device.models %}
 * {{ model }}
 {%- endfor %}
{%- endif %}
5. Boot your device with the stock OS at least once and check every functionality.
  Make sure that you can send and receive SMS and place and receive calls (also via WiFi and LTE, if available), otherwise it won't work on XPerience either! Additionally, some devices require that VoLTE/VoWiFi be utilized once on stock to provision IMS.
6. XPerience is provided as-is with no warranty. While we attempt to verify [everything works](https://github.com/TheXPerienceProject/docs/blob/master/device_requirements.md) you are installing this at your own risk!

{%- if device.before_install %}
{% capture path %}templates/device_specific/before_install_{{ device.before_install.instructions }}.md{% endcapture %}
{% include {{ path }} %}
{%- endif %}

{% if device.required_bootloader %}
## Special requirements

{% capture bootloader %}
Your device must be on bootloader version {% for el in device.required_bootloader %} {% if forloop.last %} `{{ el }}` {% else %} `{{ el }}` / {% endif %} {% endfor %}, otherwise the instructions found in this page will not work.
The current bootloader version can be checked by running the command `getprop ro.bootloader` in a terminal app or an `adb -d shell` from a command prompt (on Windows) or terminal (on Linux or macOS) window.
{% endcapture %}
{% include alerts/warning.html content=bootloader %}
{% endif %}

<script>
$(function() {
  if (window.location.hash.length === 0) {
    toggleBlur()
  }
})

function toggleBlur() {
  $('#blurred').toggleClass('blurred')
  $('#unblur').toggle()
}
</script>

<div id="unblur" style="display: none;">
  By clicking the following button you are confirming that you've met all of the basic requirements and read the warnings.<br/>
  <button onclick="toggleBlur()" class="btn btn-primary">Show instructions</button>
</div>

<div id="blurred" markdown="1">

{% if device.install_method %}
{% capture recovery_install_method %}templates/recovery_install_{{ device.install_method }}.md{% endcapture %}
{% include {{ recovery_install_method }} %}
{% else %}
## Unlocking the bootloader / Installing a custom recovery

There are no recovery installation instructions for this discontinued device.
{% endif %}

{% if device.before_install_custom %}
{% capture path %}templates/device_specific/before_install_custom_{{ device.before_install_custom }}.md{% endcapture %}
{% include {{ path }} %}
{% endif %}

## Installing XPerience from recovery

1. Download the [XPerience installation package](https://sourceforge.net/projects/xperience-aosp/files/{{ device.codename }}) that you would like to install or [build]({{ "devices/" | append: device.codename | append: "/build" | relative_url }}) the package yourself.
{%- if device.is_retrofit_dynamic_partitions and device.is_ab_device != true %}
    * You will also need to flash an empty super image since your device uses retrofitted dynamic partitions: download super_empty.img from the directory named with the latest date [here](https://mirror.math.princeton.edu/pub/lineageos/full/{{ device.codename }}/)
{%- endif %}
2. If you are not in recovery, reboot into recovery:
    * {{ device.recovery_boot }}
    {% if device.vendor == "LG" %}
        {% include templates/recovery_boot_lge.md %}
    {% endif %}
{% if device.uses_custom_recovery %}
3. Now tap **Wipe**.
4. Now tap **Format Data** and continue with the formatting process. This will remove encryption and delete all files stored in the internal storage.
5. Sideload the XPerience (example) `xperience-{{ device.current_branch}}.0.0-{{ site.time | date: "%Y%m%d" }}-{{ site.time | date: "%H%M%S" }}-UNOFFICIAL-{{ device.codename }}.zip` package:
    * On the device, select "Advanced", "ADB Sideload", then swipe to begin sideload.
    * On the host machine, sideload the package using: `adb -d sideload xperience-{{ device.current_branch}}.0.0-{{ site.time | date: "%Y%m%d" }}-{{ site.time | date: "%H%M%S" }}-UNOFFICIAL-{{ device.codename }}.zip`.
        {% include alerts/specific/tip_adb_flash_success.html %}
{% else %}
3. Now tap **Factory Reset**, then **Format data / factory reset** and continue with the formatting process. This will remove encryption and delete all files stored in the internal storage, as well as format your cache partition (if you have one).
4. Return to the main menu.
{%- if device.is_retrofit_dynamic_partitions and device.is_ab_device != true %}
5. Flash empty super image:
    * On the device, enter fastbootd mode by selecting **Advanced**, **Enter fastboot**.
    * On the host machine, flash super_empty.img using: `fastboot wipe-super super_empty.img`.
    * Once the command succeded, select **Enter recovery** on the device to return to recovery mode.
        {% include alerts/specific/note_retrofit_fastboot_wipe_super_failed.html %}
{%- if device.is_retrofit_dynamic_partitions and device.is_ab_device != true %}
        {% include alerts/specific/note_retrofit_sideload_failed.html %}
{%- endif %}
{%- endif %}
5. Sideload the XPerience (example) `xperience-{{ device.current_branch}}.0.0-{{ site.time | date: "%Y%m%d" }}-{{ site.time | date: "%H%M%S" }}-UNOFFICIAL-{{ device.codename }}.zip` package:
    * On the device, select "Apply Update", then "Apply from ADB" to begin sideload.
    * On the host machine, sideload the package using: `adb -d sideload xperience-{{ device.current_branch}}.0.0-{{ site.time | date: "%Y%m%d" }}-{{ site.time | date: "%H%M%S" }}-UNOFFICIAL-{{ device.codename }}.zip`.
        {% include alerts/specific/tip_adb_flash_success.html %}
{% endif %}
{% if device.uses_custom_recovery %}
8. Once you have installed everything successfully, run 'adb -d reboot'.
{% else %}
8. Once you have installed everything successfully, click the back arrow in the top left of the screen, then "Reboot system now".
{% endif %}

{%- capture first_boot %}
The first boot usually takes no longer than 15 minutes, depending on the device.
If it takes longer, you may have missed a step, otherwise feel free to [get assistance](#get-assistance).
{%- endcapture %}
{% include alerts/note.html content=first_boot %}

{% if device.custom_recovery_link or device.uses_custom_recovery %}
{% include alerts/specific/warning_recovery_app.html %}
{% endif %}
{% include alerts/specific/tip_sideload_stuck_47.html %}

{% if device.after_install_custom %}
{% capture path %}templates/device_specific/after_install_custom_{{ device.after_install_custom }}.md{% endcapture %}
{% include {{ path }} %}
{% endif %}

## Get assistance

After you've double checked that you followed the steps precisely, didn't skip any and still have questions or got stuck, feel free to ask on [our Telegram group](https://t.me/XPeriencechat).

</div>
