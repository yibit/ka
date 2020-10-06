using Pkg

# Basic
Pkg.add("Test")
Pkg.add("Plots")
Pkg.add("JuliaDB")
Pkg.add("DataFrames")
Pkg.add("CSV")

# CV
Pkg.add("Images")
Pkg.add("ImageMetadata")
Pkg.add("ImageView")
Pkg.add("TestImages")

# Binary
Pkg.add("ApplicationBuilder")
Pkg.add("PackageCompiler")

# Debugger
Pkg.add("Debugger")

# Update
Pkg.update()
