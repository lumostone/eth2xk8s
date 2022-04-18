{{- define "teku.unique.volumes.validator" }}
{{- $volumeDict1 := dict .dataDirPath "validator" }}
{{- $volumeDict2 := dict .validatorKeysDirPath "keys" }} 
{{- $volumeDict3 := dict .validatorKeyPasswordsDirPath "passwords" }}
{{- $volumeDict4 := dict .localDirPath "local" }}
{{- $uniqueVolumePaths := keys $volumeDict1 $volumeDict2 $volumeDict3 $volumeDict4 | uniq | sortAlpha }}
{{- $finalDict := dict }}
{{- range $path := $uniqueVolumePaths }}
  {{- $tempValue := pluck $path $volumeDict1 $volumeDict2 $volumeDict3 $volumeDict4 | join "-" | printf "teku-%s-storage" }}
  {{- $finalDict := set $finalDict $path $tempValue }}
{{- end }}
{{- toYaml $finalDict -}}
{{- end }}
