from django.urls import path
from . import views

urlpatterns = [
    path('',views.ThreadHistory.as_view())
    path('/<threadId>',views.ChatThread.as_view())
    path('/newMessage/<threadId>',view.)# incomplete
]
