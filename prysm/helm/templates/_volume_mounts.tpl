{{- define "prysm.volumeMounts" }}
{{- $uniqueVolumes := fromYaml (include "unique.volumes" . ) }}
{{- range $volumePath, $volumeName := $uniqueVolumes}}
- name: {{ $volumeName }}
  mountPath: {{ $volumePath }}
  readOnly: {{ ne $volumePath $.dataVolumePath }}
{{- end -}}
{{- end -}}
