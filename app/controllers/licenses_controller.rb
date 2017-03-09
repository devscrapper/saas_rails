class LicensesController < ApplicationController
  before_action :set_license, only: []

  # GET /licenses
  # GET /licenses.json
  def index

    @licenses = Dir.glob(Rails.root.join('public', 'licenses', "*")).map!{|f| [f,File.ctime(f)] }
  end

  # GET /licenses/1
  # GET /licenses/1.json
  def show
    render plain: (File.read(File.join("public", "licenses", "license.data"), mode: "rb"))
  end

  # GET /licenses/new
  def new
    @license = License.new
  end



  # POST /licenses
  # POST /licenses.json
  def create


    respond_to do |format|
      unless license_params['file'].nil?
        begin
          uploaded_io = license_params['file']

          # save log to /public
          File.open(Rails.root.join('public', 'licenses', uploaded_io.original_filename), 'wb') do |file|
            file.write(uploaded_io.read)
            file.close
          end
        rescue Exception => e
          format.html { render :new }
          format.json { render json: e.message, status: :unprocessable_entity }
        else
          format.html { redirect_to licenses_path, notice: 'License was successfully created.' }
          format.json { render :show, status: :created, location: @license }
        end
      end
    end
  end




  private


  # Never trust parameters from the scary internet, only allow the white list through.
  def license_params
    params[:license]
  end
end
