class Api::V1::Admin::TransactionsController < ApplicationController
    include Transactionable
    before_action :admin_only
    before_action :set_transactions, only: [:allTransactions]
    before_action :set_transaction, only: [:payoutTransaction, :showTransaction]

    def allTransactions
        render json: {  itemsremaining:  itemsRemaining(@transactions),
                        transactions: ActiveModel::SerializableResource.new(
                            @transactions,
                            each_serializer: TransactionSerializer
                        )
                    }
    end

    def showTransaction
        render json: TransactionSerializer.new( @transaction ).attributes
    end

    def payoutTransaction
        @transaction.status === "pending" ? @transaction.update(status: "transferred") : @transaction.update(status: "pending")
        render json: TransactionSerializer.new( @transaction ).attributes
    end

    private

    def admin_only
        unless user().has_role? :admin  
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end
end