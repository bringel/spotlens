file 'icomoon*/symbol-defs.svg' do

end

task 'copy-icons' => Dir.glob('icomoon*/symbol-defs.svg') do
  cp(Dir.glob('icomoon*/symbol-defs.svg').first, 'app/views/layouts/_svgicons.html.erb')
end
