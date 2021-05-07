{{- define "nimbus.unique.volumes" }}
{{- $volumeDict1 := dict .dataVolumePath "beacon" }}
{{- $volumeDict2 := dict .validatorsVolumePath "validators" }} 
{{- $volumeDict3 := dict .secretsVolumePath "secrets" }}
{{- $uniqueVolumePaths := keys $volumeDict1 $volumeDict2 $volumeDict3 | uniq }}
{{- $finalDict := dict }}
{{- if lt (len $uniqueVolumePaths) 3 }}
  {{- range $path := $uniqueVolumePaths }}
    {{- $tempValue := pluck $path $volumeDict1 $volumeDict2 $volumeDict3 | join "-" | printf "nimbus-%s-stroage" }}
    {{- $finalDict := set $finalDict $path $tempValue }}
  {{- end }}
{{- else }}
  {{- $finalDict := merge $finalDict $volumeDict1 $volumeDict2 $volumeDict3 }}
{{- end }}
{{- toYaml $finalDict -}}
{{- end }}
