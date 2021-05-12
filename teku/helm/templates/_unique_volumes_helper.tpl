{{- define "teku.unique.volumes" }}
{{- $volumeDict1 := dict .dataDirPath "validator" }}
{{- $volumeDict2 := dict .validatorKeysDirPath "keys" }} 
{{- $volumeDict3 := dict .validatorKeyPasswordsDirPath "passwords" }}
{{- $uniqueVolumePaths := keys $volumeDict1 $volumeDict2 $volumeDict3 | uniq }}
{{- $finalDict := dict }}
{{- if lt (len $uniqueVolumePaths) 3 }}
  {{- range $path := $uniqueVolumePaths }}
    {{- $tempValue := pluck $path $volumeDict1 $volumeDict2 $volumeDict3 | join "-" | printf "teku-%s-stroage" }}
    {{- $finalDict := set $finalDict $path $tempValue }}
  {{- end }}
{{- else }}
  {{- $finalDict := merge $finalDict $volumeDict1 $volumeDict2 $volumeDict3 }}
{{- end }}
{{- toYaml $finalDict -}}
{{- end }}
