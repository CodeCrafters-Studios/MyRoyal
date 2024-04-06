//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_api0v2_storage/flutter_api0v2_storage_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_api0v2_storage_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterApi0v2StoragePlugin");
  flutter_api0v2_storage_plugin_register_with_registrar(flutter_api0v2_storage_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
