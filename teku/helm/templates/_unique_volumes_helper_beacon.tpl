{{- define "teku.unique.volumes.beacon" }}
{{- $volumeDict1 := dict .dataDirPath "beacon" }}
{{- $volumeDict2 := dict .localDirPath "local" }}
{{- $uniqueVolumePaths := keys $volumeDict1 $volumeDict2 | uniq | sortAlpha }}
{{- $finalDict := dict }}
{{- range $path := $uniqueVolumePaths }}
  {{- $tempValue := pluck $path $volumeDict1 $volumeDict2 | join "-" | printf "teku-%s-storage" }}
  {{- $finalDict := set $finalDict $path $tempValue }}
{{- end }}
{{- toYaml $finalDict -}}
{{- end }}
