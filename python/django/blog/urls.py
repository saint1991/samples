from django.urls import path
from . import views

app_name = 'blog'

urlpatterns = [
    path('api/posts/', views.list_datasources, name='posts'),
]