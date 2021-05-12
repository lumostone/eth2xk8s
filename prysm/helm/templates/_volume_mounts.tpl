{{- define "prysm.volumeMounts" }}
{{- $uniqueVolumes := fromYaml (include "prysm.unique.volumes" . ) }}
{{- range $volumePath, $volumeName := $uniqueVolumes }}
- name: {{ $volumeName }}
  mountPath: {{ $volumePath }}
  readOnly: {{ ne $volumePath $.dataDirPath }}
{{- end -}}
{{- end -}}
