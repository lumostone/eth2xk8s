{{- define "prysm.unique.volumes" }}
{{- $volumeDict1 := dict .dataDirPath "validator" }} 
{{- $volumeDict2 := dict .walletDirPath "wallet" }}
{{- $uniqueVolumePaths := keys $volumeDict1 $volumeDict2 | uniq }}
{{- $finalDict := dict }}
{{- if lt (len $uniqueVolumePaths) 2 }}
  {{- range $path := $uniqueVolumePaths }}
    {{- $tempValue := pluck $path $volumeDict1 $volumeDict2 | join "-" | printf "prysm-%s-stroage" }}
    {{- $finalDict := set $finalDict $path $tempValue }}
  {{- end }}
{{- else }}
  {{- $finalDict := merge $finalDict $volumeDict1 $volumeDict2 }}
{{- end }}
{{- toYaml $finalDict -}}
{{- end }}
