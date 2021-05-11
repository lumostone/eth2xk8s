{{- define "nimbus.unique.volumes" }}
{{- $volumeDict1 := dict .dataDirPath "beacon" }}
{{- $volumeDict2 := dict .validatorsDirPath "validators" }} 
{{- $volumeDict3 := dict .secretsDirPath "secrets" }}
{{- $uniqueVolumePaths := keys $volumeDict1 $volumeDict2 $volumeDict3 | uniq | sortAlpha }}
{{- $finalDict := dict }}
{{- range $path := $uniqueVolumePaths }}
  {{- $tempValue := pluck $path $volumeDict1 $volumeDict2 $volumeDict3 | join "-" | printf "nimbus-%s-storage" }}
  {{- $finalDict := set $finalDict $path $tempValue }}
{{- end }}
{{- toYaml $finalDict -}}
{{- end }}
