from django.contrib import admin
from django.urls import path,include
from profiles import views

urlpatterns = [
    path('',views.get_query),
    # path('seeker/',views.seeker_list),
    # path('provider/',views.provider_list),
    path('reg-seeker/',views.seeker_registration,name='reg-seeker'),
    path('reg-provider/',views.provider_registration,name='reg-provider'),
    path('auth-token/',views.obtain_auth_token,name='auth-token'),
    path('provider_list',views.provider_list,name='provider_list')
]
