from django.contrib import admin
from django.urls import path,include
from profiles import views

urlpatterns = [
    path('',views.get_query),
    path('registration/',views.registration,name='registration'),
    path('login/',views.login,name='login'),
    path('buymode/',views.buyMode,name='buy-mode'),
    path('provider_registration/',views.providerRegistration,name='provider-registration'),
    path('sellmode/',views.sellMode,name='sell-mode'),
    path('addproduct/',views.addProduct,name='add-product')
]
