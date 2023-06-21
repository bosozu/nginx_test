
if (ngx.var.arg_name and ngx.var.arg_name ~= '') then
    name =  ngx.var.arg_name 
else 
    name =  "Anonymous"
end
ngx.say("Hello, ",name, "!")
