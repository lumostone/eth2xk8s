{{- define "teku.volumes.beacon" }}
{{- $uniqueVolumes := fromYaml (include "teku.unique.volumes.beacon" . ) }}
{{- range $volumePath, $volumeName := $uniqueVolumes }}
- name: {{ $volumeName }}
{{- if eq $.persistentVolumeType "nfs" }}
  nfs:
    path: {{ $volumePath }}
    server: {{ $.nfs.serverIp }}
    readOnly: false
{{- else }}
  hostPath:
    path: {{ $volumePath }}
{{- end -}}
{{- end -}}
{{- end -}}
