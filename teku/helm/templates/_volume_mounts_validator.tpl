{{- define "teku.volumeMounts.validator" }}
{{- $uniqueVolumes := fromYaml (include "teku.unique.volumes.validator" . ) }}
{{- range $volumePath, $volumeName := $uniqueVolumes }}
- name: {{ $volumeName }}
{{- if eq $volumeName "teku-local-storage"}}
  mountPath: /.local/share/teku
{{- else}}
  mountPath: {{ $volumePath }}
{{- end}}
  readOnly: {{ eq $volumePath $.validatorKeyPasswordsDirPath }}
{{- end -}}
{{- end -}}
