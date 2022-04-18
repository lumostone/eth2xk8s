{{- define "teku.volumeMounts.beacon" }}
{{- $uniqueVolumes := fromYaml (include "teku.unique.volumes.beacon" . ) }}
{{- range $volumePath, $volumeName := $uniqueVolumes }}
- name: {{ $volumeName }}
{{- if eq $volumeName "teku-local-storage"}}
  mountPath: /.local/share/teku
{{- else}}
  mountPath: {{ $volumePath }}
{{- end}}
  readOnly: false
{{- end -}}
{{- end -}}
