import 'package:flutter/material.dart';

class Categories {
  int? id;
  String name;
  String icon;

  Categories({this.id, required this.name, required this.icon});
  

  factory Categories.fromMap(Map<String, dynamic> json) =>
      Categories(id: json['id'], name: json['name'], icon: json['icon']);

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'icon': icon};

  //دالة تحويل النصوص إلى أيقونات
  IconData get iconData {
    switch (icon) {
      case 'food':
        return Icons.fastfood;
      case 'coffee':
        return Icons.coffee;
      case 'restaurant':
        return Icons.restaurant;
      case 'grocery':
        return Icons.local_grocery_store;
      case 'home':
        return Icons.home;
      case 'bills':
        return Icons.receipt_long;
      case 'water':
        return Icons.water_drop;
      case 'electricity':
        return Icons.electric_bolt;
      case 'wifi':
        return Icons.wifi;
      case 'phone':
        return Icons.phone_android;
      case 'transport':
        return Icons.directions_car;
      case 'bus':
        return Icons.directions_bus;
      case 'fuel':
        return Icons.local_gas_station;
      case 'repair':
        return Icons.build;
      case 'travel':
        return Icons.flight;
      case 'health':
        return Icons.medical_services;
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'gym':
        return Icons.fitness_center;
      case 'spa':
        return Icons.spa;
      case 'shopping':
        return Icons.shopping_bag;
      case 'gift':
        return Icons.card_giftcard;
      case 'fun':
        return Icons.sports_esports;
      case 'movie':
        return Icons.movie;
      case 'pets':
        return Icons.pets;
      case 'work':
        return Icons.work;
      case 'education':
        return Icons.school;
      case 'laptop':
        return Icons.laptop_mac;
      case 'book':
        return Icons.menu_book;
      case 'savings':
        return Icons.savings;
      case 'bank':
        return Icons.account_balance;
      case 'money':
        return Icons.payments;
      case 'investment':
        return Icons.trending_up;
      case 'debt':
        return Icons.money_off;
      case 'charity':
        return Icons.volunteer_activism;
      case 'family':
        return Icons.family_restroom;
      case 'celebration':
        return Icons.celebration;
      case 'security':
        return Icons.security;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'laundry':
        return Icons.local_laundry_service;
      default:
        return Icons.category;
    }
  }
}
