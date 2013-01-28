barbudosApp.controller 'DishesCtrl', ['$scope', 'Dish', ($scope, Dish) ->
    $scope.dishes = Dish.query()
    
    $scope.submit = ->
        dish = new Dish $scope.dish

        dish.$save $scope.dish, ->
            $scope.dishes.push dish
            $scope.dish = {}
]
