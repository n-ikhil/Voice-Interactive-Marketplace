from django.contrib import admin
from django.urls import path,include
from marketplace import views

urlpatterns = [
    path('buymode/',views.queryProduct,name='buy-mode'),
    path('sellmode/',views.sellerProductList,name='sell-mode'),
    path('addproduct/',views.addProduct,name='add-product'),
    path('product-info/',views.getProductInfo,name='product-info'),
    path('remove-product/',views.removeProduct,name='remove-product'),
    path('category-list/',views.getCategoryList,name='category-list'),
    path('product-list/',views.getProductList,name='product-list')
]
