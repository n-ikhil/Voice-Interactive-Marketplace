from django.contrib import admin
from django.urls import path,include
from marketplace import views

urlpatterns = [
    path('buymode/',views.getBuyerProductList,name='buy-mode'),
    path('provider_registration/',views.providerRegistration,name='provider-registration'),
    path('sellmode/',views.getSellerProductList,name='sell-mode'),
    path('addproduct/',views.addProduct,name='add-product')
]
