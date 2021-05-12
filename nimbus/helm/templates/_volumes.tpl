{{- define "nimbus.volumes" }}
{{- $uniqueVolumes := fromYaml (include "nimbus.unique.volumes" . ) }}
{{- range $volumePath, $volumeName := $uniqueVolumes }}
- name: {{ $volumeName }}
{{- if eq $.persistentVolumeType "nfs" }}
  nfs:
    path: {{ $volumePath }}
    server: {{ $.nfs.serverIp }}
    readOnly: {{ and (ne $volumePath $.dataDirPath) (ne $volumePath $.validatorsDirPath) }}
{{- else }}
  hostPath:
    path: {{ $volumePath }}
{{- end -}}
{{- end -}}
{{- end -}}
