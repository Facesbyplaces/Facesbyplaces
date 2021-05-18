class Api::V1::Admin::TransactionsController < ApplicationController
    before_action :check_user
    before_action :admin_only

    # Index Report
    def allTransactions
        transactions = Transaction.all
                            
        transactions = transactions.page(params[:page]).per(numberOfPage)

        if transactions.total_count == 0 || (transactions.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif transactions.total_count < numberOfPage
            itemsremaining = transactions.total_count 
        else
            itemsremaining = transactions.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        transactions: ActiveModel::SerializableResource.new(
                            transactions,
                            each_serializer: TransactionSerializer
                        )
                    }
    end

    private

    # def report_params
    #     params.require(:report).permit(:subject, :description, :reportable_type, :reportable_id)
    # end

    def admin_only
        if !user.has_role? :admin 
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end
end