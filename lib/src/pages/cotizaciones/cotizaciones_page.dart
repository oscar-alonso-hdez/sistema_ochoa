import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sistema_ochoa/src/pages/cotizaciones/header_delegate.dart';
import 'package:sistema_ochoa/src/utils/utils.dart' as utils;

import 'package:sistema_ochoa/src/providers/products_provider.dart';
import 'package:sistema_ochoa/src/Models/ProductModel.dart';

class CotizacionesPage extends StatefulWidget {
	@override
	CotizacionesPageState createState() => CotizacionesPageState();
}

class CotizacionesPageState extends State<CotizacionesPage> {
	GlobalKey<FormState> formKey; //* Key del Widget Form
	ProductModel product; //* Modelo de producto
	ProductsProvider productProvider; //* Proveedor de métodos para los procesos REST de productos
	
	//* ======= PageOne =======
	//? Valores del formulario
	String _dropDownValuePage1;
	//? Controladores
	TextEditingController _controllerDatePicker;

	//* ======= PageTwo =======
	String _dropDownValuePage2;

	@override
	void initState() {
		formKey               = new GlobalKey<FormState>();
		product               = new ProductModel();
		productProvider 			= new ProductsProvider();
		_dropDownValuePage1 	= 'Condiciones de venta';
		_controllerDatePicker = new TextEditingController();
		_dropDownValuePage2 		= 'No. de folio';
		super.initState();
	}

	@override
	void dispose() {
		_controllerDatePicker.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		//* Asignar valor inicial al TextFormField del DatePicker sin afectar a las
		//* asignaciones hechas desde el DatePicker.
		//! SI coloco el valor directamente en product.fecha pues es un valor que
		//! viene predefinido con la fecha actual en todas las cotizaciones.
		if ( utils.isToday(product.fecha) )
			_controllerDatePicker.text = product.fecha;

		return TabBarView(children: [
			_pageOne(context),
			_pageTwo(),
		]);
	}

	Widget _pageOne(BuildContext context) {
		return SingleChildScrollView(
			padding: EdgeInsets.all(16.0),
			child: Form(
				key: formKey,
				child: Column(
					children: [
						_createLabelDivider('Datos de cotización'),
						_createTFFDatePicker(context),
						_createSpace(16.0),
						_createTFFFolio(),
						_createSpace(16.0),
						_createTFFNoReq(),
						_createSpace(24.0),
						_createLabelDivider('Datos del cliente'),
						_createTFFCliente(),
						_createSpace(16.0),
						_createTFFDireccion(),
						_createSpace(16.0),
						_createTFFComprador(),
						_createSpace(16.0),
						_createTFFDepartamento(),
						_createSpace(24.0),
						_createLabelDivider('Otros datos'),
						_createDBFFCondicionesV(),
						_createSpace(16.0),
						_createTFFTiempoE(),
						_createSpace(24.0),
						_createButton()
					],
				),
			),
		);
	}

	Widget _pageTwo() {
		return CustomScrollView(

			slivers: <Widget>[_createHeader(), _createBody()],
		);
	}

	//? Página 2: Consultar cotizaciones
	SliverPersistentHeader _createHeader() {
		return SliverPersistentHeader(
			delegate: HeaderDelegate(dropDownValue: _dropDownValuePage2, updateValue: _updateText),
			pinned: true
		);
	}

	SliverFillRemaining _createBody() {
		// TODO: Crear FTBuilder que muestre la lista de resultados,
		// todo: y poner este widget como initialData.
		return SliverFillRemaining( //* Widget que extiende a su hijo en el area visible restante de la pantalla
			hasScrollBody: false,
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Icon(Icons.search_off, size: 200.0, color: Colors.grey),
					Text(
						'No hay búsquedas recientes',
						style: Theme.of(context).textTheme.subtitle2
					),
				],
			),
		);
		
		
		// return SliverList(
		// 	delegate: SliverChildListDelegate([
		//     SingleChildScrollView(
					
		//       padding: EdgeInsets.all(16.0),
		//       child: Container(
		//         color: Colors.blue,
		//         alignment: Alignment.bottomCenter,
		//         child: Text(
		//           'No hay búsquedas recientes',
		//           style: Theme.of(context).textTheme.subtitle2,
		//         ),
		//       ),
		//     )
		//   ])
		// );
	}

	//* Utilidades
	void _updateText(String value) {
		setState(() {
			_dropDownValuePage2 = value;
		});
	}

	//? Página 1: "Nueva cotización"
	TextFormField _createTFFDatePicker(BuildContext context) {
		return TextFormField(
			controller: _controllerDatePicker,
			decoration: InputDecoration(
					labelText: 'Fecha de solicitud', border: OutlineInputBorder()),
			onTap: () => _createDatePicker(context),
			validator: (value) => utils.formFieldIsEmpty(value),
			onSaved: (value) => product.fecha = value,
		);
	}

	TextFormField _createTFFFolio() {
		return TextFormField(
			decoration: InputDecoration(
					labelText: 'Folio de la cotización', border: OutlineInputBorder()),
			validator: (value) => utils.formFieldIsEmpty(value),
			onSaved: (value) => product.folio = value,
		);
	}

	TextFormField _createTFFNoReq() {
		return TextFormField(
			decoration: InputDecoration(
					labelText: 'No. de requisición', border: OutlineInputBorder()),
			validator: (value) => utils.formFielIsNumeric(value),
			onSaved: (value) => product.noReq = num.parse(value),
		);
	}

	TextFormField _createTFFCliente() {
		return TextFormField(
			decoration:
					InputDecoration(labelText: 'Cliente', border: OutlineInputBorder()),
			validator: (value) => utils.formFieldIsEmpty(value),
			onSaved: (value) => product.cliente = value,
		);
	}

	TextFormField _createTFFDireccion() {
		return TextFormField(
			decoration:
					InputDecoration(labelText: 'Dirección', border: OutlineInputBorder()),
			validator: (value) => utils.formFieldIsEmpty(value),
			onSaved: (value) => product.direccion = value,
		);
	}

	TextFormField _createTFFComprador() {
		return TextFormField(
			decoration:
					InputDecoration(labelText: 'Comprador', border: OutlineInputBorder()),
			validator: (value) => utils.formFieldIsEmpty(value),
			onSaved: (value) => product.comprador = value,
		);
	}

	TextFormField _createTFFDepartamento() {
		return TextFormField(
			decoration: InputDecoration(
					labelText: 'Departamento', border: OutlineInputBorder()),
			validator: (value) => utils.formFieldIsEmpty(value),
			onSaved: (value) => product.departamento = value,
		);
	}

	Widget _createDBFFCondicionesV() {
		return DropdownButtonFormField<String>(
			value: _dropDownValuePage1,
			onChanged: (optSelect) => setState(() => _dropDownValuePage1 = optSelect),
			items: <String>[
				'Condiciones de venta',
				'De contado',
				'A crédito',
				'50% de contado, 50% a crédito'
				]
				.map((String opt) => DropdownMenuItem(child: Text(opt), value: opt))
				.toList(),
			validator: (value) => utils.dropDownIsValid(value),
			onSaved: (value) => product.condicionesVenta = value,
		);
	}

	TextFormField _createTFFTiempoE() {
		return TextFormField(
			decoration: InputDecoration(
				labelText: 'Tiempo de entrega', border: OutlineInputBorder()
			),
			validator: (value) => utils.formFieldIsEmpty(value),
			onSaved: (value) => product.tiempoEntrega = value,
		);
	}

	Align _createButton() {
		return Align(
			alignment: Alignment.centerRight,
			child: TextButton(
					child: Text('Siguiente'),
					onPressed: () {
						//* Si hay algun error, no se ejecutan las lineas despues de esta
						//* condición. Es decir que no se guardan los datos del formulario.
						if (!formKey.currentState.validate()) return;

						formKey.currentState.save();
						print(product.toJson());

						productProvider.crearProducto(product);
					}),
		);
	}

	//* utilidades
	Widget _createLabelDivider(String label) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text(label),
				Divider(thickness: 1.0, color: Theme.of(context).primaryColor)
			],
		);
	}

	Widget _createSpace(double height) => SizedBox(height: height);

	void _createDatePicker(BuildContext context) async {
		//* Hacer que el TextFormField no tome el foco
		FocusScope.of(context).requestFocus(new FocusNode());

		//* Ejecutar el DatePicker
		DateTime date = await showDatePicker(
				context: context,
				initialDate: DateTime.now(),
				firstDate: DateTime(2018),
				lastDate: DateTime(2021));

		//* Asignar la fecha seleccionada en el DatePicker al TextFormField
		if (date != null) {
			setState(() {
				//? Darle formato de dia/mes/año a la fecha obtenida del DatePicker
				//? y actualizar el valor de fecha en el producto.
				product.fecha = DateFormat('dd/MM/yyyy').format(date);

				//? Asignar el valor al controlador del TextFormField
				_controllerDatePicker.text = product.fecha;
			});
		}
	}
}
