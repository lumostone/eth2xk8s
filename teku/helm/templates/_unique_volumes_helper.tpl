{{- define "teku.unique.volumes" }}
{{- $volumeDict1 := dict .dataDirPath "validator" }}
{{- $volumeDict2 := dict .validatorKeysDirPath "keys" }} 
{{- $volumeDict3 := dict .validatorKeyPasswordsDirPath "passwords" }}
{{- $uniqueVolumePaths := keys $volumeDict1 $volumeDict2 $volumeDict3 | uniq | sortAlpha }}
{{- $finalDict := dict }}
{{- range $path := $uniqueVolumePaths }}
  {{- $tempValue := pluck $path $volumeDict1 $volumeDict2 $volumeDict3 | join "-" | printf "teku-%s-storage" }}
  {{- $finalDict := set $finalDict $path $tempValue }}
{{- end }}
{{- toYaml $finalDict -}}
{{- end }}
