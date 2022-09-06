module ka

function sayHello()
    println("Hello World!")
end

function julia_main()::Cint
    sayHello()
    return 0
end

end # module ka
