{{- define "prysm.unique.volumes" }}
{{- $volumeDict1 := dict .dataDirPath "validator" }} 
{{- $volumeDict2 := dict .walletDirPath "wallet" }}
{{- $uniqueVolumePaths := keys $volumeDict1 $volumeDict2 | uniq | sortAlpha }}
{{- $finalDict := dict }}
{{- range $path := $uniqueVolumePaths }}
  {{- $tempValue := pluck $path $volumeDict1 $volumeDict2 | join "-" | printf "prysm-%s-storage" }}
  {{- $finalDict := set $finalDict $path $tempValue }}
{{- end }}
{{- toYaml $finalDict -}}
{{- end }}
