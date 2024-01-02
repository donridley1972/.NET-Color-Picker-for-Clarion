  MEMBER('DotNetColorPickerDemo.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('DotNetColorPickerDemo_BC0.CLW')
DotNetColorPickerDemo_BC0:DctInit             PROCEDURE()
DotNetColorPickerDemo_BC0:DctKill             PROCEDURE()
DotNetColorPickerDemo_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  DotNetColorPickerDemo_BC0:DctInit
  DotNetColorPickerDemo_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  DotNetColorPickerDemo_BC0:DctKill

