# rack static framework

basic router; erb views

## erb/md/html files:

     file.erb     : html format
     file_md.erb  : markdown
     layout.erb   : main layout template 
     not_found_md.erb   : custom 404 handler view 
     file.html    : html file
    
## directories: 

    erb files    :  views/
    html files   :  public/
    assets files :  public/css/,
                    public/img/,
                    public/js/

## define routes hash:
    {'/path' => :name }
    {'/path' => :name_md }
    {'/path_a', '/path_x' => :name }

```ruby
    get('/path_1', '/path_n'){ :file_md }
    get('/static'){ :index_html }
    Router.map['/about'] = :about
    Router['/', '/home'] = :index
    Router.map.merge!('/first' => :first, '/next'=> :next )
```
