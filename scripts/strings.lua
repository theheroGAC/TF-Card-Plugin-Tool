----------------strings------------------------

------------------关于--------------------------*
APP_NAME = "TF卡插件工具 [TF card plug-in tool]"
APP_VERSION = "v2.0"
APP_BUILD_DATE = "2018.03.20"
APP_NAME_VERSION = APP_NAME.." "..APP_VERSION

------------------弹窗--------------------------*
TIPS = "Operation check"
INTRODUCTION = "Explanation"
PLEASE_SELECT = "Please select"
BUTTON_POSITIVE = "〇..(Yes)"
BUTTON_CANCEL = "X..(No)"
BUTTON_BACK = "X..(Close)"
BUTTON_QUIT = "X..(Quit)"
BUTTON_PASS = "△..(Skip)"
WAIT_LOADING = "Loading. Please wait..."
WAIT_EXECUTING = "It is being processed. Please wait..."
WAIT_CANCELING = "It is canceling. Please wait..."
WAIT_CHECKING_APP = "Game safety Testing..."
WAIT_INSTALLING_APP = "Installing the game.%s，Please wait..."

------------------callbacks--------------------------*
CALLBACKS_COPYING = "Copy"
CALLBACKS_DELETING = "Delete"
CALLBACKS_EXTRACTING = "Extraction"
CALLBACKS_COMPRESSING = "Compression"
CALLBACKS_DOWNLOADING = "Download"
CALLBACKS_SCANING = "Scan"
CALLBACKS_FILE_NAME = "File name: %s"
CALLBACKS_PERCENT = "Progress: %s %%"
CALLBACKS_FILE_SIZE = "File size: %s"
CALLBACKS_TOTAL_PERCENT = "Overall progress: %s %%"
CALLBACKS_TOTAL_FILE_SIZE = "Total file size: %s"
CALLBACKS_HAVE_COPYED = "Copying in progress: %s"
CALLBACKS_HAVE_EXTRACTED = "Extracting: %s"
CALLBACKS_HAVE_DOWNLOADED = "Downloading: %s"
CALLBACKS_HAVE_COPYED = "Copying in progress: %s"

CALLBACKS_SCAN_APP_UNSAFE = "This package requests extended permissions.\nIt will have access to your personal information.\nIf you did not obtain it from a trusted source,\nplease proceed at your own caution.\n\nWould you like to continue the install?"
CALLBACKS_SCAN_APP_DANGEROUS = "warning!\nThis package uses functions that remounts\npartitions and can potentially brick your device.\nIf you did not obtain it from a trusted source,\nplease proceed at your own caution.\n\nWould you like to continue the install?"

------------------主页--------------------------*
SAFE_MODE_TIP = "HENkaku is in 'SAFE MODE'.\n\nPlease turn on 'Enable Unsafe Homebrew' in the setting of HENkaku."
BATTERY_SHOW = "Battery: %s%%"

MOUNT_TF_UMA = "SD2VITA = uma0 / MemoryCard = ux0"
MOUNT_TF_UX = "SD2VITA = ux0  / MemoryCard = uma0"
MOUNT_USB_UX = "USB ---> ux0  (PSTV Only)"
UNMOUNT_TF_USB_PLUGINS = "Uninstall TF card and USB plug-in"
REFRESH_APP = "Refresh LiveArea"
EXPLORE = "File Manager"
ABOUT = "About"

MAIN_BUTTON_SELECT = "SELECT ： FTP Connection"
MAIN_BUTTON_POSITIVE = "Main menu ： ○..(Decision)"

FTP_SERVER = "FTP Server"
WLAN_ON = "Wi-Fi :    ON"
WLAN_OFF = "Wi-Fi :    OFF"
FTP_ON = "FTP :    Start\n\n ftp://%s:1337 \n\nThe FTP service has been started.\n\nDo you want to end it?"
FTP_OFF = "FTP :    Stop\n\nThe FTP service has not started.\n\nWould you like to start?\n\nAfter starting, the FTP address is displayed in the lower right."
FTP_INFORMATION_TIP = "ftp://%s:1337"

INSTALL_TF_USB_MODE_SELECT_OLD = "3.60 Fixation/Non-Fixation"
INSTALL_TF_USB_MODE_SELECT_NEW = "3.60/3.65/3.67 Fixation"

INSTALL_TF_USB_READY = "Swap the mount of the selected drive.\n\n %s \n\nAre you sure you want to proceed?"
INSTALL_TF_USB_COMPLETE = "Mount replacement of drive\n\n %s \n\nProcessing is completed.\n\nWould you like to reboot the device now and enable it?"
UNINSTALL_TF_USB_READY = "Uninstall TF card plug-in and USB plug-in.\n\nAre you sure you want to proceed?"
UNINSTALL_TF_USB_COMPLETE = "Uninstallation of TF card plug-in and USB plug-in has been completed.\n\nWould you like to reboot the device now and enable it?"

NO_CONFIG = "can not find the config.txt file. The operation was canceled!"

ABOUT_TXT = "Producer: 一直改\n(百度psvita破解吧)\nVersion: "..APP_VERSION.."   Date: "..APP_BUILD_DATE
UPDATE_LOG = "Change log"
BUTTON_UPDATE_LOG = "△Change log"

---------------刷新游戏气泡----------------------------------------
PSV_MANAGER_REFRESH_APP_READY = "Refresh LiveArea.\n\nThis may take time.\n\nAre you sure you want to proceed?"
PSV_MANAGER_REFRESH_APP_COMPLETE = "Refresh of LiveArea is completed.\n\n%s Bubble icons."
PSV_MANAGER_REFRESH_APP_NO_DIR = "Directory not found. The operation was canceled!"

----------------文件管理器----------------------------------------
EXPLORE_NO_DISK = "Can not find a usable drive ..."
EXPLORE_NO_FILE = "File is missing ..."
EXPLORE_DIRECTORY = "Folder"

EXPLORE_DEVINFO_INFORMATION = "Use %s  /  Total %s"
EXPLORE_DEVINFO_NO_INFORMATION = "Drive not found"

EXPLORE_BUTTON_MARK = "□ : Mark"
EXPLORE_BUTTON_OPEN_MENU = "△ : Open menu"
EXPLORE_BUTTON_BACK = "X : Back"
EXPLORE_BUTTON_POSITIVE = "○ : Decision"
EXPLORE_BUTTON_SWITCH_DISK = "← / → : Drive switching"

EXPLORE_MARKS_ALL = "Select all"
EXPLORE_UNMARKS_ALL = "Deselect all"
EXPLORE_COPY = "Copy"
EXPLORE_CUT = "Cut"
EXPLORE_PASTE = "Past"
EXPLORE_DELETE = "Delete"
EXPLORE_RENAME = "Rename"
EXPLORE_MAKE_ZIP = "Compression"
EXPLORE_CREATE_FILE = "New file"
EXPLORE_MAKE_DIR = "New folder"
EXPLORE_INSTALL_APPDIR = "Create game folder"
EXPLORE_EXPORT_MULTIMEDIA = "Export multimedia files"
EXPLORE_QUIT = "Quit"

EXPLORE_FREESPACE_NOTENOUGH = "The remaining capacity is insufficient. The operation was canceled!"

EXPLORE_INSTALL_APP_SAMPLE = "Install normal game"
EXPLORE_INSTALL_APP_NONPDRM = "Install NoNpDrm game"

EXPLORE_DELETE_READY = "Are you sure you want to delete these%s files?"
EXPLORE_DELETE_COMPLETE = "Total%sfiles deleted."

EXPLORE_RENAME_COMPLETE = "Rename success."
EXPLORE_RENAME_FAILED = "Rename failure!"
EXPLORE_RENAME_FAILED_ALREADY_EXISTS = "Rename failed!\n\nA file or folder with the same name already exists."

EXPLORE_OPEN_ZIP_FAILED = "Failed to decompress!"
EXPLORE_OPEN_UKNOW_FILE_READY = "Current file format is unknown. Open in a text editor?"

EXPLORE_MAKE_ZIP_READY = "Are you sure you want to compress the selected file into a zip file?\n(Note: This function is unstable and it may crash.)"
EXPLORE_MAKE_ZIP_FAILED = "Failed to create zip file!"

EXPLORE_CREATE_FILE_FAILED = "Failed to create the file!"
EXPLORE_CREATE_FILE_FAILED_ALREADY_EXISTS = "Failed to create the file!\n\nA file or folder with the same name already exists."

EXPLORE_MAKE_DIR_FAILED = "Failed to create the folder!"
EXPLORE_MAKE_DIR_FAILED_ALREADY_EXISTS = "Failed to create the folder!\n\nA file or folder with the same name already exists."

EXPLORE_INSTALL_APP_READY = "Are you sure you want to install these%s games?"
EXPLORE_INSTALL_APP_UN_UX_READY = "Are you sure you want to install these%s games?\n(Hint: There is a problem that can not be archived for games installed on uma 0 or ur 0 drive.\nBecause some games do not work properly, we do not recommend installing games on uma 0 or ur 0)"
EXPLORE_INSTALL_APP_COMPLETE = "Total%s games have been installed."
EXPLORE_INSTALL_APP_NO_UX_DISK = "The ux 0 drive could not be found. The operation has been canceled!"
EXPLORE_INSTALL_APP_NO_DST_DISK = "The target drive could not be found and the operation was aborted!"

EXPLORE_EXPORT_MULTIMEDIA_READY = "Are you sure you want to export these%s multimedia files?"
EXPLORE_EXPORT_MULTIMEDIA_COMPLETE = "Total%s multimedia files have been exported."

----------------Text Editor---------------------*
TEXTEDITOR_BUTTON_INSERT_LINE = "□ : Line deletion"
TEXTEDITOR_BUTTON_DELETE_LINE = "△ : Line addition"
TEXTEDITOR_BUTTON_POSITIVE = "○ : Line edit"
TEXTEDITOR_BUTTON_LR = "L/R : Page up/down"
TEXTEDITOR_BUTTON_BUTTON_QUIT = "X : Quit"

TEXTEDITOR_PLEASE_INPUT = "Please input."

TEXTEDITOR_BUTTON_SAVE = "○ : Save"
TEXTEDITOR_BUTTON_UNSAVE = "△ : Non-save"

TEXTEDITOR_FILE_TOO_BIG = "Too many rows. Only 1 to 9999 lines are displayed."
TEXTEDITOR_QUIT_SAVE_READY = "Quit the text editor.\n\nDo you want to save before exiting?"
TEXTEDITOR_SAVING = "Saving. Please wait..."
TEXTEDITOR_SAVE_COMPLETE = "Saving is completed."









