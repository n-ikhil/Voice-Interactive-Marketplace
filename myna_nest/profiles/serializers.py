from rest_framework import serializers
from .models import Seeker,Provider
from django.conf import settings

class SeekerSerializer(serializers.ModelSerializer):
	class Meta:
		model = Seeker
		fields = ['email','phno']



class ProviderSerializer(serializers.ModelSerializer):
	class Meta:
		model = Provider
		fields = ['user','title','phno','address','services']