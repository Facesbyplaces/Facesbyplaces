class Api::V1::Admin::TransactionsController < ApplicationController
    before_action :admin_only
    before_action :set_transaction, only: [:payoutTransaction, :showTransaction]

    # Index Report
    def allTransactions
        render json: {  itemsremaining:  itemsRemaining(transactions),
                        transactions: ActiveModel::SerializableResource.new(
                            transactions,
                            each_serializer: TransactionSerializer
                        )
                    }
    end

    def showTransaction
        render json: TransactionSerializer.new( @transaction ).attributes
    end

    def payoutTransaction
        if @transaction.status === "pending"
            @transaction.update(status: "transferred")
        elsif @transaction.status === "transferred"
            @transaction.update(status: "pending")
        end

        render json: TransactionSerializer.new( @transaction ).attributes
    end

    private

    def itemsRemaining(transactions)
        if transactions.total_count == 0 || (transactions.total_count - (params[:page].to_i * numberOfPage)) < 0
            return itemsremaining = 0
        elsif transactions.total_count < numberOfPage
            return itemsremaining = transactions.total_count 
        else
            return itemsremaining = transactions.total_count - (params[:page].to_i * numberOfPage)
        end
    end

    def transactions
        transactions = Transaction.all         
        return transactions = transactions.page(params[:page]).per(numberOfPage)
    end

    def transaction
        @transaction = Transaction.find(params[:id])
    end 

    def admin_only
        unless user().has_role? :admin  
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end
end