from rest_framework import serializers
from .models import Category,StandardProduct,StandardProductName


class CategorySerializer(serializers.ModelSerializer):
	
	class Meta:
		model = Category
		fields = ['name']
		
class StandardProductNameSerializer(serializers.ModelSerializer):

	class Meta:
		model = StandardProductName
		fields = ['language','name']


class StandardProductSerializer(serializers.ModelSerializer):
	altNames = StandardProductNameSerializer(many=True,read_only=True)
	class Meta:
		model = StandardProduct
		fields = ['name','altNames']