# Troubleshoot the Ingress Controller with App Protect Integration

This document describes how to troubleshoot problems with the Ingress Controller with the [App Protect](/nginx-app-protect/) module enabled.

For general troubleshooting of the Ingress Controller, check the general [troubleshooting](/nginx-ingress-controller/troubleshooting/) documentation.

For additional troubleshooting of the App Protect module itself, check the [troubleshooting](/nginx-app-protect/troubleshooting/) guide in the App Protect module documentation. 

## Potential Problems

The table below categorizes some potential problems with the Ingress Controller when App Protect module is enabled. It suggests how to troubleshoot those problems, using one or more methods from the next section.

```eval_rst
.. list-table::
   :header-rows: 1

   * - Problem area
     - Symptom
     - Troubleshooting method
     - Common cause
   * - Start.
     - The Ingress Controller fails to start.
     - Check the logs.
     - Misconfigured APLogConf or APPolicy.
   * - APLogConf, APPolicy or Ingress Resource.
     - The configuration is not applied.
     - Check the events of the APLogConf, APPolicy and Ingress Resource, check the logs.
     - APLogConf or APPolicy is invalid.
   * - NGINX.
     - The Ingress Controller NGINX verification timeouts while starting for the first time or while reloading after a change.
     - Check the logs for ``Unable to fetch version: X`` message.
     - Too many Ingress Resources with App Protect enabled. Check the `NGINX fails to start/reload section <#nginx-fails-to-start-or-reload>`_ of the Known Issues. 
```

## Troubleshooting Methods

### Check the Ingress Controller and App Protect logs

App Protect logs are part of the Ingress Controller logs when the module is enabled. To check the Ingress Controller logs, follow the steps of [Checking the Ingress Controller Logs](/nginx-ingress-controller/troubleshooting/#checking-the-ingress-controller-logs) of the Troubleshooting guide.

For App Protect specific logs, look for messages starting with `APP_PROTECT`, for example:
```
2020/07/10 11:13:20 [notice] 17#17: APP_PROTECT { "event": "configuration_load_success", "software_version": "2.52.1", "completed_successfully":true,"attack_signatures_package":{"revision_datetime":"2020-06-18T10:11:32Z","version":"2020.06.18"}}
```

### Check events of an Ingress Resource

Follow the steps of [Checking the Events of an Ingress Resource](/troubleshooting/#checking-the-events-of-an-ingress-resource).

### Check events of APLogConf

After you create or update an APLogConf, you can immediately check if the NGINX configuration was successfully applied by NGINX:
```
$ kubectl describe aplogconf logconf
Name:         logconf
Namespace:    default
. . . 
Events:
  Type    Reason          Age   From                      Message
  ----    ------          ----  ----                      -------
  Normal  AddedOrUpdated  11s   nginx-ingress-controller  AppProtectLogConfig  default/logconf was added or updated
```
Note that in the events section, we have a `Normal` event with the `AddedOrUpdated` reason, which informs us that the configuration was successfully applied.

### Check events of APPolicy

After you create or update an APPolicy, you can immediately check if the NGINX configuration was successfully applied by NGINX:
```
$ kubectl describe appolicy dataguard-alarm
Name:         dataguard-alarm
Namespace:    default
. . . 
Events:
  Type    Reason          Age    From                      Message
  ----    ------          ----   ----                      -------
  Normal  AddedOrUpdated  2m25s  nginx-ingress-controller  AppProtectPolicy default/dataguard-alarm was added or updated
```
Note that in the events section, we have a `Normal` event with the `AddedOrUpdated` reason, which informs us that the configuration was successfully applied.
 
## Run App Protect in Debug Mode

When you set the Ingress Controller to use debug mode, the setting also applies to the App Protect module.  See  [Running NGINX in the Debug Mode](/nginx-ingress-controller/troubleshooting/#running-nginx-in-the-debug-mode) for instructions.

## Known Issues

When using the Ingress Controller with the App Protect module, the following issues have been reported. The occurrence of these issues is commonly related to a higher number of Ingress Resources with App Protect being enabled in a cluster.

When you make a change that requires NGINX to apply a new configuration, the Ingress Controller reloads NGINX automatically. Without the App Protect module enabled, usual reload times are around 150ms. If App Protect module is enabled and is being used by any number of Ingress Resources, these reloads might take a few seconds instead. 

### NGINX Configuration Skew

If you are running more than one instance of the Ingress Controller, the extended reload time may cause the NGINX configuration of your instances to be out of sync. This can occur because there is no order imposed on how the Ingress Controller processes the Kubernetes Resources. The configurations will be the same after all instances have completed the reload.

In order to reduce these inconsistencies, we advise that you do not apply changes to multiple resources handled by the Ingress Controller at the same time. 

### NGINX Fails to Start or Reload

The first time the Ingress Controller starts, or whenever there is a change that requires reloading NGINX, the Ingress Controller will verify if the reload was successful. The timeout for this verification is normally 4 seconds. When App Protect is enabled, this timeout is 20 seconds. 

This timeout should be more than enough to verify configurations. However, when numerous Ingress Resources with App Protect enabled are handled by the Ingress Controller at the same time, you may find that you need to extend the timeout further.  Examples of when this might be necessary include:

- You need to apply a large amount of Ingress Resources at once.
- You are running the Ingress Controller for the first time in a cluster where the Ingress Resources with App Protect enabled are already present.

You can increase this timeout by setting the `nginx-reload-timeout` [cli-argument](/nginx-ingress-controller/configuration/global-configuration/command-line-arguments/#cmdoption-nginx-reload-timeout).
