# rack static router

basic router; erb views

## directories: 

  erb files    :  public/views
  assets files :  public/css,
                  public/img

## define routes hash:

  format: {'/path' => :basename_symbol }

ex:
 
  Router.merge!(
      '/'      => :index,
      '/about' => :about
    )
