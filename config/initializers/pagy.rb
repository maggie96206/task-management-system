require "pagy"
require "pagy/extras/overflow"


# Pagy 9.x 的正確設定方式
Pagy::DEFAULT[:limit] = 10
Pagy::DEFAULT[:overflow] = :last_page
