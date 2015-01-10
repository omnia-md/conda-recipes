$PYTHONS = @("27", "33", "34")
$NUMPYS = @("18", "19")

If ($args.count -eq 0) {
    Write-Host "Usage:" $MyInvocation.MyCommand.Name "[one-or-more-conda-recipes...]"
    Write-Host
    Write-Host "Build conda packages with all versions of python."
    exit 1
}

foreach ($py in $PYTHONS) {
foreach ($npy in $NUMPYS) {
    foreach ($recipe in $args) {
        $env:CONDA_PY = $py
        $env:CONDA_NPY = $npy
        $output = conda build $recipe --output
        if (Test-Path $output) {
            Write-Host "package exists:" $output
            continue
        }
        conda build $recipe
   }
}
}
