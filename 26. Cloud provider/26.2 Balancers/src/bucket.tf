// Create Service Account
resource "yandex_iam_service_account" "sa-bucket" {
    name        = "sa-for-bucket"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
    folder_id   = var.folder_id
    role        = "storage.editor"
    member      = "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
    depends_on  = [yandex_iam_service_account.sa-bucket]
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
    service_account_id = yandex_iam_service_account.sa-bucket.id
    description        = "static access key for bucket"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "vologin-bucket" {
    access_key  = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key  = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket      = "vologin-bucket"
    acl         = "public-read"
}

// Add picture to bucket
resource "yandex_storage_object" "bucket_image" {
    access_key  = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key  = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket      = yandex_storage_bucket.vologin-bucket.bucket
    key         = "bucket_image.webp"
    source      = "bucket_image.webp"
    acl         = "public-read"
    depends_on  = [yandex_storage_bucket.vologin-bucket]
}
