let
  sam-macbook-air = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcFIcpkymnv2XQ+mH6dUeVdc2Dt0kBNUweVdTxZw6xMNoa1Wsd7Ro0KgSStnDOO0xc6LvKIovj18QtlQ76D2xlyygxFjtS+q8FrjTeVnsJWl7DTrJXbIzFpP7LutcQ07qKSpL4FYslxTqwyoQs71SlLX2HkKWXHaeRbd/kAqZzRiwf2o/VRD5neNVqDSiOZbyMY7cYkMPtowk787xVUeyQQwzwRfQP1wXwvFwjhNtNe7JjnrPuJxTjTeCeHU1DV5FCt/T7CydyM6EAhrDECwf0rqJmyNs7Gq1Yf2QeMkTra7eM3oQxbjilkhUm1dXHs3pyzbjOMiPTTD2k42e14QEo1/tiJpvJq91jQ/d+zwUU9n/oApQ/FKyY1t0JRob3axEE7xeQfPgWNTDDVPCnP4YapXfOfPrvgRiDR1mZw9Y7fXifLZV0wgQcW/9NGM9NNPre6IG30ZrVBIW3SOIZViBH9xqyaHwubp+ANIKN8reFpntLMOCLv7/+ug3gom83JDU= samweston@Sams-Air.lan.cablespaghetti.dev";
  tinymac = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuyETk8fx+IXp7qvM1d75wSlI9TXND6ubNd8my1luVJ sam@tinymac";
  users = [sam-macbook-air tinymac];

  chonky = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDjsPX015E/Vw/UK1RMyhxyIOmGPlZtSfR5LbjvAgGv1/b2Mie6owo3qP4sH4NAW6V6ZANb0G3cIsqLbhOv9h6l82PLHxXXqrmrLINJ1JIQro7V0RD96PVbo4R4TvrM4mmWntogwY5IFZf5AEmjXag2mExLg2Ttd0cfwv+/BWMWuR1BTrjqn5Y2iyc7d53JH2WEEZflspGkbWQsjgckjemZjbUhId32JjC1BOzogcIWZ0ep2BEQpQK8u5sxGS1+YFQ6emnhYWXt85p0yA+5kuX2kwc02JiPaWtKv8JngKa/su+kXhI/SZg91px5CFWC7BCS3UqNNY41xROAL1VYuMzjJyikOTo9xrlsGjqyAnP+kHKYv4Pon2SORsUhGqEIWacJJ+2mBBIHEgUS2N6kPAaoffV5a1YgJ6XVL3kAwRZ3ti/vTFoiBwXibsURlpighckcwmKCrI2OkjM3D0UZElT+X2RcFRtqqETydIdX1s+Qreuv13HuuXCewqprP6uBUfjaTNnVyVrGG6SW21nBjg51PRr+/5ypvY8DzAH6EeSTNE6zD1Ah2YXFV6ngpmIUDPWuEx3tK2XS0SkJ7fErevdf4PP7CJVNdGv/dqdL9uazpf9kHAkuS7EVPVSh3lYaBbmaS4G6/gkPZDVZ78MJD5dMIKR3Ep2euUmEKHfJW9Dl9w== root@chonky";
  nixos-web-vps = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCZg4+a+3GXa1z36WSFJ5V36etFfMMYZDDtQknIdUa+ovMRHin4XPAKR28th+KHgoRkjfPQ2UxTUQrXcT79RF9zCUDTFeQPruM8X3Zf3MF+w2TD3mtlMBHqtCnFu0Ps3JAVX2CuLLyfINSolUmnnxVHpKGFKpQrpKlrasDGG/2fjqOAJP/S7tKksLN5sY/FZKeH1gEk3TU4CPy4a9fjvKIgPjrT5aIrL7yYJvW1ZcXxFNCsWN5A+1ysiyQdJ+wmDeI9N5Mj8Hqrr7XrVhj2soLzhcuRyQFwiwGva8ejOnzVxw4yFAHs6/d3y8fiQXMj+RpwHc77zOl0CHzeQOwjQ3/zAPI8BC+xp7L/bv1Tpc0CHFb0GOHuH/F+xXaNun4RcpFQhACGGooH9Lf2IBK4vU1inhnqHIv6/dbtDmAXI7um9JbAAbWKOfX57fnLTCNRsqRi/yQcvcWx7IrikZqGCWIGdNRi6qpPPgbOdY+fSUGtWV0App/bqcBXXOg6dOnyZts= root@server-jaapuy";
  nixos-web-bakery = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKTUF+koDhXuJ94x32uQeS+G2ceqLIgIB0f5m0LOLPd root@hayleysbakery.com";
  runningcafe-web1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXTs2FQJlqJbT/39qihOyqfw6UTUzbzvuU9y26C9PM+ root@nixos";
  runningcafe-web2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCSRGmTrA2jj52Bm+8+JT+y0O8nizc5hOq7OONuLMDI root@nixos";
  systems = [nixos-web-vps nixos-web-bakery runningcafe-web1 runningcafe-web2 chonky];
in {
  "caddy-cloudflare.age".publicKeys = users ++ [chonky];
  "grafana-password.age".publicKeys = users ++ systems;
  "grafana-logs-password.age".publicKeys = users ++ systems;
  "restic-environmentfile.age".publicKeys = users ++ [chonky nixos-web-vps nixos-web-bakery];
  "restic-password.age".publicKeys = users ++ [chonky nixos-web-vps nixos-web-bakery];
  "smtp-username.age".publicKeys = users ++ systems;
  "smtp-password.age".publicKeys = users ++ systems;
  "tonywinn-wordpress.age".publicKeys = users ++ [nixos-web-vps];
  "hayleysbakery-database.age".publicKeys = users ++ [nixos-web-bakery];
}
