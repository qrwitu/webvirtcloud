# Generated by Django 2.2.12 on 2020-05-27 07:01

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('instances', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='PermissionSet',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
            options={
                'permissions': (('clone_instances', '允许克隆实例'),),
                'managed': False,
                'default_permissions': (),
            },
        ),
    ]
