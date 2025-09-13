from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone


class DataSource(models.Model):
    datasource_id = models.AutoField(primary_key=True)
    datasource_name = models.CharField(max_length=100)
    type = models.CharField(max_length=20, choices=[("file", "file"), ("database", "database"), ("url", "url"), ("folder", "folder")])
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    size = models.BigIntegerField()


class DataFrames(models.Model):
    dataframe_id = models.AutoField(primary_key=True)
    dataframe_name = models.CharField(max_length=100)
    datasource_id = models.IntegerField()
    project_id = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
