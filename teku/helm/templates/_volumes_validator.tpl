{{- define "teku.volumes.validator" }}
{{- $uniqueVolumes := fromYaml (include "teku.unique.volumes.validator" . ) }}
{{- range $volumePath, $volumeName := $uniqueVolumes }}
- name: {{ $volumeName }}
{{- if eq $.persistentVolumeType "nfs" }}
  nfs:
    path: {{ $volumePath }}
    server: {{ $.nfs.serverIp }}
    readOnly: {{ eq $volumePath $.validatorKeyPasswordsDirPath }}
{{- else }}
  hostPath:
    path: {{ $volumePath }}
{{- end -}}
{{- end -}}
{{- end -}}
