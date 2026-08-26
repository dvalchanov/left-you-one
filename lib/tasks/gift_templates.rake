namespace :gifts do
  namespace :templates do
    desc "Import the editable gift-template library"
    task import: :environment do
      templates = GiftTemplates::Importer.call
      puts "Imported #{templates.size} gift templates."
    end
  end
end
