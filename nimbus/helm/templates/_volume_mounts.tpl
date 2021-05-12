{{- define "nimbus.volumeMounts" }}
{{- $uniqueVolumes := fromYaml (include "nimbus.unique.volumes" . ) }}
{{- range $volumePath, $volumeName := $uniqueVolumes }}
- name: {{ $volumeName }}
  mountPath: {{ $volumePath }}
  readOnly: {{ and (ne $volumePath $.dataDirPath) (ne $volumePath $.validatorsDirPath) }}
{{- end -}}
{{- end -}}
