using Pkg

# Update
Pkg.update()

# Basic
Pkg.add("Test")

# Database
Pkg.add("JuliaDB")
Pkg.add("DataFrames")
Pkg.add("CSV")

# Plot
# https://github.com/JuliaPlots/Plots.jl
Pkg.add("Plots")
# https://juliagraphs.org/GraphPlot.jl
Pkg.add("GraphPlot")
# https://github.com/GiovineItalia/Gadfly.jl
Pkg.add("Gadfly")

# Julia kernel for Jupyter
Pkg.add("IJulia")
Pkg.add("Pluto")

# Math
Pkg.add("LinearAlgebra")
Pkg.add("SparseArrays")
# Applied Linear Algebra. Vectors, Matrices, and Least Squares https://github.com/VMLS-book/VMLS.jl
# Pkg.add("VMLS") # add https://github.com/VMLS-book/VMLS.jl

# CV
Pkg.add("Images")
Pkg.add("ImageMetadata")
Pkg.add("ImageView")
Pkg.add("TestImages")

# ML
# https://github.com/FluxML/Flux.jl
Pkg.add("Flux")
# https://github.com/denizyuret/Knet.jl
#Pkg.add("Knet")
# https://github.com/bensadeghi/DecisionTree.jl
Pkg.add("DecisionTree")
# https://github.com/JuliaML/LIBSVM.jl
Pkg.add("LIBSVM")

# RDatasets
Pkg.add("RDatasets")

# Binary
Pkg.add("ApplicationBuilder")
Pkg.add("PackageCompiler")

# Debugger
Pkg.add("Debugger")

# Tools
# https://github.com/JuliaGizmos/Interact.jl
#Pkg.add("Interact")
# https://github.com/JuliaGraphics/Colors.jl
Pkg.add("Colors")
