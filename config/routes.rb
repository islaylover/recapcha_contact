Rails.application.routes.draw do
　・
　・
　・
  root 'index#index'
  scope "(:locale)", :locale => /ja|en/ do
    ・
    ・
    get 'inquiry' => 'contact#inquiry'　　#追記
    post 'confirm' => 'contact#confirm' #追記
    post 'finish' => 'contact#finish'   #追記
 　　　 ・
  end
  
end

