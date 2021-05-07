{{- define "nimbus.volumeMounts" }}
{{- $uniqueVolumes := fromYaml (include "unique.volumes" . ) }}
{{- range $volumePath, $volumeName := $uniqueVolumes}}
- name: {{ $volumeName }}
  mountPath: {{ $volumePath }}
  readOnly: {{ and (ne $volumePath $.dataVolumePath) (ne $volumePath $.validatorsVolumePath) }}
{{- end -}}
{{- end -}}
