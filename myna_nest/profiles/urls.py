from django.contrib import admin
from django.urls import path,include
from profiles import views

urlpatterns = [
    path('',views.get_query),
    path('registration/',views.registration,name='registration'),
    path('login/',views.login,name='login'),
    path('provider_list',views.provider_list,name='provider_list')
]
